classdef MyQuaternion
%% Class for representing and manipulating quaternions
%
% Q = MyQuaternion(s, v) returns a quaternion s + xi + yj + zk
    
    properties
        % Scalar part of quaternion (w)
        s;
        
        % Vector part of quaternion ([x y z])
        v;
    end
    
    methods
        % Constructor
        function Q = MyQuaternion(s, v)
            Q.s = s;
            Q.v = v;
        end
        
        % Quaternion Multiplication
        function q = times(Q, Q2)
            q = MyQuaternion(0, [0 0 0]);
            q.s = (Q.s * Q2.s) - dot(Q.v, Q2.v);
            q.v = (Q.s .* Q2.v) + (Q2.s .* Q.v) + cross(Q.v, Q2.v);
        end
        
        % Quaternion Division
        function q = divide(Q, Q2)
           q = MyQuaternion(0, [0 0 0]);
           q.s = (Q.s * Q2.s) + dot(Q.v, Q2.v);
           q.v = (Q2.s * Q.v) - (Q.s * Q2.v) - cross(Q.v,Q2.v);
        end
        
        % Quaternion Addition
        function q = plus(Q, Q2)
            q = MyQuaternion(0, [0 0 0]);
            q.s = Q.s + Q2.s;
            q.v = Q.v + Q2.v;
        end
        
        % Quaternion Subtraction
        function q = minus(Q, Q2)
           Q2 = Q2.times_scalar(-1);
           q = Q.plus(Q2);
        end
        
        % Quaternion times scalar
        function q = times_scalar(Q, s)
            q = MyQuaternion(0, [0 0 0]);
            q.s = Q.s * s;
            q.v = Q.v * s;
        end
        
        % Normalize to unit quaternion
        function q = normalize(Q)
            q = MyQuaternion(0, [0 0 0]);
            mag_sqr = Q.s^2 + sum(Q.v.^2);
            if abs(mag_sqr) > 0.0001
                mag = sqrt(mag_sqr);
                q.s = Q.s / mag;
                q.v = Q.v ./ mag;
            end
        end
        
        % Quaternion Norm
        function n = norm(Q)
           n = sqrt(Q.s^2 + sum(Q.v .^ 2)); 
        end
        
        % Quaternion Conjugate
        function q = conjugate(Q)
            q = MyQuaternion(0, [0 0 0]);
            q.s = Q.s;
            q.v = Q.v .* -1;
        end
        
        % Get quaternion magnitude
        function L = magnitude(Q)
            L = sqrt(Q.s^2 + sum(Q.v .^ 2));
        end
        
        % Rotate a 3-vector by this quaternion
        function vr = rotateVector(Q, v)
           q = Q.conjugate;
           vq = MyQuaternion(0.0, v);
           qr = Q.times(vq);
           qr = qr.times(q);
           vr = Q.v;
        end
        
        % Convert to Euler angles
        function [roll, pitch, yaw] = toEuler(Q, rads)
            if ~exist('rads','var') || isempty(rads)
                rads = false; 
            end
            
            % Make Unit Quaternion
            q = Q.normalize();
            
            % Roll
            ra = (q.v(2) * q.v(3) + q.s * q.v(1));
            rb = 0.5 - (q.v(1)^2 + q.v(2)^2);
            
            % Yaw
            ya = (q.s * q.v(3) + q.v(1) * q.v(2));
            yb = 0.5 - (q.v(2)^2 + q.v(3)^2);
            
            if rads
                roll = atan2(ra, rb);
                pitch = asin(-2.0 * (q.v(1) * q.v(3) - q.s * q.v(2)));
                yaw = atan2(ya, yb);
            else
                roll = atan2d(ra, rb);
                pitch = asind(-2.0 * (q.v(1) * q.v(3) - q.s * q.v(2)));
                yaw = atan2d(ya, yb);
            end
        end
        
        % Convert to Rotation Matrix
        function M = toRotationMatrix(Q)
            Q = Q.normalize();
            
            m1 = [1-2*(Q.v(2)^2 + Q.v(3)^2),... 
                2*(Q.v(1)*Q.v(2) - Q.v(3)*Q.s),...
                2*(Q.v(1)*Q.v(3) + Q.v(2)*Q.s)];
            
            m2 = [2*(Q.v(1)*Q.v(2) + Q.v(3)*Q.s) ,...
                1-2*(Q.v(1)^2 + Q.v(3)^2),...
                2*(Q.v(2)*Q.v(3) - Q.v(1)*Q.s)];
            
            m3 = [2*(Q.v(1)*Q.v(3) - Q.v(2)*Q.s) ,...
                2*(Q.v(2)*Q.v(3) + Q.v(1)*Q.s) ,...
                1-2*(Q.v(1)^2 + Q.v(2)^2)];
            
            M = [m1; m2; m3];
        end
        
        % Convert to Axis-Angle
        function [a x y z] = toAxisAngle(Q)
            Q = Q.normalize();
            
            if Q.s == 1
                a = 0;
                x = 0;
                y = 0;
                z = 0;
                return;
            end
            
            if Q.s == 0
                a = 180;
                x = Q.v(1);
                y = Q.v(2);
                z = Q.v(3);
                return;
            end
            
            n = sqrt(1 - Q.s^2);
            a = 2 * atan2d(n, Q.s);
            x = (Q.v(1) / n);
            y = (Q.v(2) / n);
            z = (Q.v(3) / n);
        end
    end
    
end

